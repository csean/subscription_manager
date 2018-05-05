json.current_page @subscribers.current_page
json.total_pages @subscribers.total_pages
json.next_page @subscribers.next_page
json.prev_page @subscribers.prev_page
json.per_page @subscribers.current_per_page
json.subscribers do
  json.array! @subscribers, partial: 'subscribers/subscriber', as: :subscriber
end
