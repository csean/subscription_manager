json.(subscription, :id, :start_date, :next_billing_date, :created_at, :updated_at)
json.url subscription_url(subscription, format: :json)
json.subscriber do
  json.(subscription.subscriber, :id, :name, :email)
end
json.item do
  json.(subscription.item, :id, :name)
  json.price humanized_money_with_symbol(subscription.item.price)
end
