module API
  class Root < Grape::API
    format :json

    get do
      {hello: 'world'}
    end
  end
end