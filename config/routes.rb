::Rails.application.routes.draw do

  enabled = !!(::Rails.application.config.enable_code_sync_server == true) rescue false

  if enabled == true
    root = ::Rails.root

    adapter = CodeSync::SprocketsAdapter.new(root: root)

    server_info = CodeSync::Server::ServerInfo.new({
      sprockets: adapter,
      root: root
    })

    source_provider = CodeSync::Server::SourceProvider.new({
      sprockets: adapter,
      root: root
    })

    scope "/code-sync", :module => "code_sync" do
      get "/canvas", :to => "canvas#index"
      get "/info", :to => server_info
      match "/source", :to => source_provider
    end
  end

end
