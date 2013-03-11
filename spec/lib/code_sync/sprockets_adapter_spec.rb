require "spec_helper"

describe CodeSync::SprocketsAdapter do 
  let(:coffeescript) do
    asset = File.join(CodeSync.spec_root,'support','site','app','assets','javascripts','spec_application_javascript.coffee')
    content = IO.read(asset)
  end

  let(:env) do
    site = File.join(CodeSync.spec_root, 'support', 'site')
    CodeSync::SprocketsAdapter.new(root: site)
  end

  let(:manifest) do
    asset = File.join(CodeSync.spec_root,'support','site','app','assets','javascripts','manifest.coffee')
    IO.read(asset)    
  end

  it "should be able to find an asset" do
    env.find_asset('spec_application_javascript.coffee').should_not be_nil
  end

  it "should be able to compile an asset by filename" do
    env.find_asset("spec_application_javascript.coffee").to_s.should match(/SpecApplication.prototype.boot/)
  end

  it "should be able to compile an asset by path" do
    path = File.join(CodeSync.spec_root,'support','site','app','assets','javascripts','spec_application_javascript.coffee')
    env.find_asset(path).to_s.should match(/SpecApplication.prototype.boot/)
  end

  it "should be able to compile a coffeescript string into an asset" do
    env.compile(coffeescript, type:"coffeescript").should match("SpecApplication.prototype.boot")
  end

  it "should be able to compile a javascript manifest" do
    compiled = env.compile(manifest, type:"coffeescript")

    compiled.should match("SpecApplication.prototype.boot")
    compiled.should match("SpecLib")
    compiled.should match("SpecVendorJavascript")
  end

end