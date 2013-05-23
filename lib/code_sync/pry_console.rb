require 'multi_json'
require 'pry'

puts "Defining Pry Session Server"

# Thanks to the rack-webconsole-pry project
# for showing me the way to handle this
module CodeSync
  class PrySessionServer
    def initialize(app, options={})
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      params  = request.params

      return @app.call(env) unless request.post? && (authenticate(params,env) && params['code'])

      process(params['code'])
    end

    protected

      def process(code)
        response = {}

        if $pry.nil?
          Pry.pager = false
          $pry_output         = StringIO.new("")
          $pry_output.string  = ""
          $pry                = Pry.new(output: $pry_output, pager: false)
          Pry.initial_session_setup
        end

        pry = $pry

        puts "hi"
        binding.pry

        # repl loop
        if pry.binding_stack.last
          target = Pry.binding_for(pry.binding_stack.last)
        else
          target = Pry.binding_for(TOPLEVEL_BINDING)
        end

        pry.repl_prologue(target) unless pry.binding_stack.last == target
        pry.inject_sticky_locals(target)

        response[:prompt] = pry.select_prompt("", target) + Pry::Code.new(code).to_s

        received_output = false

        begin

          read_pipe, write_pipe = IO.pipe
          end_line              = "~~~~pry-console output end~~~~"

          puts "getting to the thread"

          thread = Thread.new do
            while true
              new_line = read_pipe.readline
              break if new_line == end_line
              $pry_output << new_line
            end
          end

          old_stdout = STDOUT.dup
          old_stderr = STDERR.dup

          STDOUT.reopen(write_pipe)
          STDERR.reopen(write_pipe)

          if !pry.process_command(code, "", target)
            result = target.send(:eval, code, Pry.eval_path, Pry.current_line)
            received_output = true
          end

          if received_output
            pry.set_last_result(result, target, code)
            Pry.print.call($pry_output, result) if pry.should_print?
          end

          $pry_output.write(error_out) if error_out

          response[:result] = $pry_output.string

          respond_with(response)

        rescue StandardError => e
          error_out = "Error: " + e.message

        ensure
          write_pipe << end_line

          thr.join
          read_pipe.close
          write_pipe.close
          STDOUT.reopen(old_stdout)
          STDERR.reopen(old_stderr)

          puts "Enrusre"
        end

      end


      # Outputs a hash that has a
      #   - prompt
      #   - result
      #
      def respond_with(hash)
        response_body = MultiJson.encode(hash)

        headers = {
          "Content-Type" => "application/json",
          "Content-Length" => response_body.bytesize.to_s
        }
      end


      def authenticate(params, env)
        true
      end

      def setup_pry_process

      end
  end
end
