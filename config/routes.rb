if ::Rails.env.development?
  ::Rails.application.routes.draw do
    server_info = CodeSync::Server::ServerInfo.new({
      sprockets: ::Rails.application.assets,
      root: ::Rails.root
    })

    source_provider = CodeSync::Server::SourceProvider.new({
      sprockets: ::Rails.application.assets,
      root: ::Rails.root
    })

    scope "/code-sync" do
      get "/assets", :to => ::Rails.application.assets,
      get "/info", :to => server_info,
      match "/source", :to => source_provider
    end
  end
end