module V1
  module Users
      class Api < Grape::API
      format :json

      mount Profile
      mount Users

      add_swagger_documentation hide_documentation_path: true,
                                mount_path: "/user_swagger_doc_v1",
                                doc_version: '0.0.1',
                                api_version: "v1",
                                info: {
                                  title: 'User API v1',
                                },
                                array_use_braces: true

    end
  end
end
