require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "works! (now write some real specs)" do
      get "/posts.json"
      expect(response).to have_http_status(200)
    end
  end

  describe "Get /show" do
    it "shows" do
      user = User.create!(name: "julia", email: "julia@test.com", password: "password")
      post = Post.create!(user_id: user.id, title: "test", body: "body text")

      get "/posts/#{post.id}.json"
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["body"]).to eq("body text")
    end
  end

  describe "create post" do
    it "will create a post" do
      user = User.create!(name: "julia", email: "julia@test.com", password: "password")
      jwt = JWT.encode({ user_id: user.id },
                       Rails.application.credentials.fetch(:secret_key_base), "HS256")

      post "/posts", params: { user_id: user.id, title: "New title", body: "Body text" },
                     headers: { "Authorization" => "Bearer #{jwt}" }

      expect(response).to have_http_status(200)
    end

    it "will return unauthorized no jwt token" do
      user = User.create!(name: "julia", email: "julia@test.com", password: "password")
      jwt = JWT.encode({ user_id: user.id },
                       Rails.application.credentials.fetch(:secret_key_base), "HS256")

      post "/posts", params: { user_id: user.id, title: "New title", body: "Body text" }

      expect(response).to have_http_status(401)
    end

    it "will return 400 error for missing params" do
      user = User.create!(name: "julia", email: "julia@test.com", password: "password")
      jwt = JWT.encode({ user_id: user.id },
                       Rails.application.credentials.fetch(:secret_key_base), "HS256")

      post "/posts", params: { user_id: user.id, body: "Body text" },
                     headers: { "Authorization" => "Bearer #{jwt}" }

      expect(response).to have_http_status(400)
    end
  end
end
