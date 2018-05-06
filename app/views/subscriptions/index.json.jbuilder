json.partial! 'shared/pagination', collection: @subscriptions
json.subscriptions do
  json.array! @subscriptions, partial: 'subscriptions/subscription', as: :subscription
end
