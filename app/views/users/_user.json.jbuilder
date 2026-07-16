json.extract! user, :id, :email, :post_code, :prefecture_code, :city, :street, :created_at, :updated_at
json.url user_url(user, format: :json)
