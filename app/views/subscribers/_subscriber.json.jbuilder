json.extract! subscriber, :id, :name, :email, :created_at, :updated_at
json.url subscriber_url(subscriber)
json.subscriptions do
  json.array! subscriber.subscriptions, partial: 'subscriptions/subscription', as: :subscription, locals: { embedded: true }
end
