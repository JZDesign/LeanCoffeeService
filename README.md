# LeanCoffeeService

## Things to note

When signing in Authentication is basic.

**Header Example**: `Authorization: Basic Base64Encoded(aladdin:opensesame)`

After that it's bearer token auth


# API Docs

## Create User


**POST** `{{URL}}/api/users`

**Request Body**

```json
{
    "name": "{{name}}",
    "username": "{{username}}",
    "password": "{{password}}"
}
```

**Response**

```json
{
    "id": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "name": "Domenica71",
    "username": "Elsie_Walsh"
}
```


## Get User


**GET** `{{URL}}/api/users/{{userid}}`

**Response**

```json
{
    "id": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "name": "Domenica71",
    "username": "Elsie_Walsh"
}
```

## Sign In

**POST** `{{URL}}/api/users/login`

**Header** `Authorization: Basic {{userid:password}} <- base64 encoded`

**Response**

``` json
{
    "value": "RkIwWBT7MuTlADXbZbLX9A==",
    "user": {
        "id": "478E0ACB-DFC5-432B-B553-321399AF3735"
    },
    "id": "C0621223-373A-405D-BC03-2209EBF6106C"
}
```

**Note** the "value" is the bearer token you need to store.

## Create Lean Coffee 

**POST** `{{URL}}/api/leancoffee`


**Header** `Authorization: Bearer {{token value}}`


**Request Body**

```json
{
    "title": "A title"
}
```
**Response**

```json
{
    "id": "BE43F38A-4E52-4DC7-B8B7-0AEFCE42F914",
    "title": "A title",
    "host": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "date": "2021-08-21T19:25:10Z"
}
```

## Get Lean Coffee

**GET** `{{URL}}/api/leancoffee/{{leancoffee_id}}`

**Header** `Authorization: Bearer {{token value}}`

**Response**

```json
{
    "id": "BE43F38A-4E52-4DC7-B8B7-0AEFCE42F914",
    "title": "A title",
    "host": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "date": "2021-08-21T19:25:10Z"
}
```


## Get all topics in a Lean Coffee

**GET** `{{URL}}/api/leancoffee/{{leancoffee_id}}/topics`

**Header** `Authorization: Bearer {{token value}}`

**Response**

```json
[
    {
        "id": "538721AA-47BB-4CB6-BB20-02AD1F84EDBB",
        "title": "A title",
        "introducer": "12F5C0C6-0651-44B0-AF7E-686849099B03",
        "description": "",
        "completed": false,
        "votes": [
            {
                "topic": {
                    "id": "538721AA-47BB-4CB6-BB20-02AD1F84EDBB"
                },
                "id": "62055814-62E5-4BEF-B8CE-BF903AA63882",
                "user": "12F5C0C6-0651-44B0-AF7E-686849099B03"
            }
        ]
    },
]
```
## Get Lean Coffee Host

**GET** `{{URL}}/api/leancoffee/{{leancoffee_id}}/host`

**Header** `Authorization: Bearer {{token value}}`

**Response**

```json
{
    "id": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "name": "Domenica71",
    "username": "Elsie_Walsh"
}
```


## Get all Lean Coffee events

**GET** `{{URL}}/api/leancoffee/`

**Header** `Authorization: Bearer {{token value}}`

**Response**

```json
[
    {
        "id": "08D5937E-7126-4491-A04A-23DA3FDC9D38",
        "title": "A title",
        "host": "12F5C0C6-0651-44B0-AF7E-686849099B03",
        "date": "2021-08-21T00:00:00Z"
    },
    {
        "id": "1C8400D0-F3AC-4161-AFC9-82C41B9A949F",
        "title": "A title",
        "host": "F8A213CA-5D30-4C7C-9CAC-C139F11C1D5E",
        "date": "2021-08-21T00:00:00Z"
    },
    {
        "id": "BE43F38A-4E52-4DC7-B8B7-0AEFCE42F914",
        "title": "A title",
        "host": "478E0ACB-DFC5-432B-B553-321399AF3735",
        "date": "2021-08-21T00:00:00Z"
    }
]
```

## Create Topic

**POST** `{{URL}}/api/topics`


**Header** `Authorization: Bearer {{token value}}`


**Request Body**

```json
{
    "title": "A title",
    "leanCoffeeId": "{{leancoffee_id}}",
    "description": ""
}
```
**Response**

```json
{
    "leanCoffee": {
        "id": "BE43F38A-4E52-4DC7-B8B7-0AEFCE42F914"
    },
    "id": "C6645F36-4DDB-44F4-8C76-1FB25A236A53",
    "introducer": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "title": "A title",
    "completed": false,
    "description": ""
}
```

## Get Topic

**GET** `{{URL}}/api/topics/{{topic_id}}`


**Header** `Authorization: Bearer {{token value}}`


**Response**

```json
{
    "leanCoffee": {
        "id": "BE43F38A-4E52-4DC7-B8B7-0AEFCE42F914"
    },
    "id": "C6645F36-4DDB-44F4-8C76-1FB25A236A53",
    "introducer": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "title": "A title",
    "completed": false,
    "description": ""
}
```

## Get Topic Introducer

**GET** `{{URL}}/api/topics/{{topic_id}}/introducer`


**Header** `Authorization: Bearer {{token value}}`


**Response**

```json
{
    "id": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "name": "Domenica71",
    "username": "Elsie_Walsh"
}
```

## Get Topic Votes

**GET** `{{URL}}/api/topics/{{topic_id}}/votes`


**Header** `Authorization: Bearer {{token value}}`


**Response**

```json
[
    {
        "id": "FCB75BAE-A63C-4A85-8674-9A6F5F16CDFC",
        "topic": {
            "id": "C6645F36-4DDB-44F4-8C76-1FB25A236A53"
        },
        "user": "478E0ACB-DFC5-432B-B553-321399AF3735"
    }
]
```

## Get Topic's parent lean coffee

**GET** `{{URL}}/api/topics/{{topic_id}}/leancoffee`


**Header** `Authorization: Bearer {{token value}}`


**Response**

```json
{
    "id": "BE43F38A-4E52-4DC7-B8B7-0AEFCE42F914",
    "title": "A title",
    "host": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "date": "2021-08-21T00:00:00Z"
}
```

## Cast vote

**POST** `{{URL}}/api/votes`


**Header** `Authorization: Bearer {{token value}}`


**Request Body**

```json
{
    "topicId": "{{topic_id}}"
}
```

**Response**

```json
{
    "id": "FCB75BAE-A63C-4A85-8674-9A6F5F16CDFC",
    "user": "478E0ACB-DFC5-432B-B553-321399AF3735",
    "topic": {
        "id": "C6645F36-4DDB-44F4-8C76-1FB25A236A53"
    }
}
```
