json.partial! 'shared/pagination', collection: @subscribers
json.subscribers do
  json.array! @subscribers, partial: 'subscribers/subscriber', as: :subscriber
end
