# README

## About
This site takes in arguments to create a subscription, and if successfully able to process the payment through a billing gateway, returns info about the subscription.

It also can list out a paginated response of subscriptions and subscribers.

## Prerequisites

### Billing Gateway Service

I used the example from here: https://gist.github.com/freezepl/2a75c29c881982645156f5ccf8d1b139

The credentials file needs to have an entry with the same keys as the credentials.yml.sample file

### Ruby Version

This app was developed with Ruby 2.5.1 but should be able to run on Ruby 2.3 and later

### Database

This app was developed using Postgres but should be able to use any db of choice

NOTE: Please run `rake seed:migrate` before starting the app. It populates one item with a cost of $100.

## Running the App

### Subscriptions

#### List subscriptions: GET `/subscriptions`

Sample Response:
```{
    "total_pages": 1,
    "current_page": 1,
    "next_page": null,
    "prev_page": null,
    "current_per_page": 25,
    "subscriptions": [
        {
            "id": 1,
            "start_date": "2018-05-05",
            "next_billing_date": "2018-06-05",
            "created_at": "2018-05-06T03:21:44.964Z",
            "updated_at": "2018-05-06T03:21:44.964Z",
            "url": "http://localhost:3000/subscriptions/1.json",
            "subscriber": {
                "id": 1,
                "name": "Sean",
                "email": "sean@sean.com"
            },
            "item": {
                "id": 1,
                "name": "Fay Breitenberg",
                "price": "$100"
            }
        },
        {
            "id": 2,
            "start_date": "2018-05-05",
            "next_billing_date": "2018-06-05",
            "created_at": "2018-05-06T04:37:05.981Z",
            "updated_at": "2018-05-06T04:37:05.981Z",
            "url": "http://localhost:3000/subscriptions/2.json",
            "subscriber": {
                "id": 1,
                "name": "Sean",
                "email": "sean@sean.com"
            },
            "item": {
                "id": 1,
                "name": "Fay Breitenberg",
                "price": "$100"
            }
        },
        {
            "id": 3,
            "start_date": "2018-05-11",
            "next_billing_date": "2018-05-11",
            "created_at": "2018-05-11T23:01:26.330Z",
            "updated_at": "2018-05-11T23:01:26.330Z",
            "url": "http://localhost:3000/subscriptions/3.json",
            "subscriber": {
                "id": 1,
                "name": "Sean",
                "email": "sean@sean.com"
            },
            "item": {
                "id": 1,
                "name": "Fay Breitenberg",
                "price": "$100"
            }
        },
        {
            "id": 4,
            "start_date": "2018-05-11",
            "next_billing_date": "2018-05-11",
            "created_at": "2018-05-11T23:02:41.328Z",
            "updated_at": "2018-05-11T23:02:41.328Z",
            "url": "http://localhost:3000/subscriptions/4.json",
            "subscriber": {
                "id": 1,
                "name": "Sean",
                "email": "sean@sean.com"
            },
            "item": {
                "id": 1,
                "name": "Fay Breitenberg",
                "price": "$100"
            }
        }
    ]
}
```
Takes an optional `page` param

#### Show subscription: GET `/subscription/1`

Sample Response:
```
{
    "id": 1,
    "start_date": "2018-05-05",
    "next_billing_date": "2018-06-05",
    "created_at": "2018-05-06T03:21:44.964Z",
    "updated_at": "2018-05-06T03:21:44.964Z",
    "url": "http://localhost:3000/subscriptions/1.json",
    "subscriber": {
        "id": 1,
        "name": "Sean",
        "email": "sean@sean.com"
    },
    "item": {
        "id": 1,
        "name": "Fay Breitenberg",
        "price": "$100"
    }
}
```

#### Creating subscription: POST `/subscriptions`

Sample Input:
```
{
	"subscription": {
		"item_id": 1,
		"cc_number": "a valid cc number",
		"expiration_month": "a valid month",
		"expiration_year": "a valid year",
		"cvv": "123",
		"subscriber_attributes": {
			"name": "Sean",
			"email": "sean@sean.com"
		}
	}
}
```

Validations are performed on `item_id`, `cc_number`, expiration date, `cvv`, subscriber `name`, and subscriber `email`.

Credit number must be a valid credit card number, and expiration must occur in the current month or any future month.

The app will return a 200 response code if successfully created, 400 if insufficent funds, a 422 if there is a validation error on the parameters, and a 500 if it is not able to successfully communicate with the billing gateway (after five attempts)
.
Successful Response:
```
{
    "id": 5,
    "start_date": "2018-05-11",
    "next_billing_date": "2018-05-11",
    "created_at": "2018-05-11T23:21:45.556Z",
    "updated_at": "2018-05-11T23:21:45.556Z",
    "url": "http://localhost:3000/subscriptions/5.json",
    "subscriber": {
        "id": 1,
        "name": "Sean",
        "email": "sean@sean.com"
    },
    "item": {
        "id": 1,
        "name": "Fay Breitenberg",
        "price": "$100"
    }
}
```

Insufficient Funds Response:
```
{
    "error": "insufficient_funds"
}
```

Invalid Credit Card Response:
```
{
    "cc_number": [
        "is invalid"
    ]
}
```

### Subscribers

#### List subscribers: GET `/subscribers`

Sample Response:
```
{
    "total_pages": 1,
    "current_page": 1,
    "next_page": null,
    "prev_page": null,
    "current_per_page": 25,
    "subscribers": [
        {
            "id": 2,
            "name": "Danielle",
            "email": "booga@gooba.com",
            "created_at": "2018-05-06T05:03:40.342Z",
            "updated_at": "2018-05-06T05:03:40.342Z",
            "url": "http://localhost:3000/subscribers/2",
            "subscriptions": []
        },
        {
            "id": 1,
            "name": "Sean",
            "email": "sean@sean.com",
            "created_at": "2018-05-05T20:46:56.767Z",
            "updated_at": "2018-05-05T20:46:56.767Z",
            "url": "http://localhost:3000/subscribers/1",
            "subscriptions": [
                {
                    "id": 1,
                    "start_date": "2018-05-05",
                    "next_billing_date": "2018-06-05",
                    "created_at": "2018-05-06T03:21:44.964Z",
                    "updated_at": "2018-05-06T03:21:44.964Z",
                    "url": "http://localhost:3000/subscriptions/1.json",
                    "item": {
                        "id": 1,
                        "name": "Fay Breitenberg",
                        "price": "$100"
                    }
                },
                {
                    "id": 2,
                    "start_date": "2018-05-05",
                    "next_billing_date": "2018-06-05",
                    "created_at": "2018-05-06T04:37:05.981Z",
                    "updated_at": "2018-05-06T04:37:05.981Z",
                    "url": "http://localhost:3000/subscriptions/2.json",
                    "item": {
                        "id": 1,
                        "name": "Fay Breitenberg",
                        "price": "$100"
                    }
                },
                {
                    "id": 3,
                    "start_date": "2018-05-11",
                    "next_billing_date": "2018-05-11",
                    "created_at": "2018-05-11T23:01:26.330Z",
                    "updated_at": "2018-05-11T23:01:26.330Z",
                    "url": "http://localhost:3000/subscriptions/3.json",
                    "item": {
                        "id": 1,
                        "name": "Fay Breitenberg",
                        "price": "$100"
                    }
                },
                {
                    "id": 4,
                    "start_date": "2018-05-11",
                    "next_billing_date": "2018-05-11",
                    "created_at": "2018-05-11T23:02:41.328Z",
                    "updated_at": "2018-05-11T23:02:41.328Z",
                    "url": "http://localhost:3000/subscriptions/4.json",
                    "item": {
                        "id": 1,
                        "name": "Fay Breitenberg",
                        "price": "$100"
                    }
                },
                {
                    "id": 5,
                    "start_date": "2018-05-11",
                    "next_billing_date": "2018-05-11",
                    "created_at": "2018-05-11T23:21:45.556Z",
                    "updated_at": "2018-05-11T23:21:45.556Z",
                    "url": "http://localhost:3000/subscriptions/5.json",
                    "item": {
                        "id": 1,
                        "name": "Fay Breitenberg",
                        "price": "$100"
                    }
                }
            ]
        }
    ]
}
```

Takes an optional `page` param

#### Show subscriber: GET `/subscribers/1`

Sample Response:
```
{
    "id": 1,
    "name": "Sean",
    "email": "sean@sean.com",
    "created_at": "2018-05-05T20:46:56.767Z",
    "updated_at": "2018-05-05T20:46:56.767Z",
    "url": "http://localhost:3000/subscribers/1",
    "subscriptions": [
        {
            "id": 1,
            "start_date": "2018-05-05",
            "next_billing_date": "2018-06-05",
            "created_at": "2018-05-06T03:21:44.964Z",
            "updated_at": "2018-05-06T03:21:44.964Z",
            "url": "http://localhost:3000/subscriptions/1.json",
            "item": {
                "id": 1,
                "name": "Fay Breitenberg",
                "price": "$100"
            }
        },
        {
            "id": 2,
            "start_date": "2018-05-05",
            "next_billing_date": "2018-06-05",
            "created_at": "2018-05-06T04:37:05.981Z",
            "updated_at": "2018-05-06T04:37:05.981Z",
            "url": "http://localhost:3000/subscriptions/2.json",
            "item": {
                "id": 1,
                "name": "Fay Breitenberg",
                "price": "$100"
            }
        },
        {
            "id": 3,
            "start_date": "2018-05-11",
            "next_billing_date": "2018-05-11",
            "created_at": "2018-05-11T23:01:26.330Z",
            "updated_at": "2018-05-11T23:01:26.330Z",
            "url": "http://localhost:3000/subscriptions/3.json",
            "item": {
                "id": 1,
                "name": "Fay Breitenberg",
                "price": "$100"
            }
        },
        {
            "id": 4,
            "start_date": "2018-05-11",
            "next_billing_date": "2018-05-11",
            "created_at": "2018-05-11T23:02:41.328Z",
            "updated_at": "2018-05-11T23:02:41.328Z",
            "url": "http://localhost:3000/subscriptions/4.json",
            "item": {
                "id": 1,
                "name": "Fay Breitenberg",
                "price": "$100"
            }
        },
        {
            "id": 5,
            "start_date": "2018-05-11",
            "next_billing_date": "2018-05-11",
            "created_at": "2018-05-11T23:21:45.556Z",
            "updated_at": "2018-05-11T23:21:45.556Z",
            "url": "http://localhost:3000/subscriptions/5.json",
            "item": {
                "id": 1,
                "name": "Fay Breitenberg",
                "price": "$100"
            }
        }
    ]
}
```
