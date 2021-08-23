# LeanCoffeeService

![Swift](https://img.shields.io/badge/Swift-FA7343?logo=swift&logoColor=white)
![Made with Vapor](https://img.shields.io/badge/vapor-4-df43f6.svg?logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAAEzo7pQAAABmFBMVEUAAAD%2F%2F%2F%2F%2FgP%2F%2FgP9mzP9V1f%2BA1f9Vxv9G0f9EzP9L0v9Dyf9Sv%2F9Pwf9Gxf9Exv9Fx%2F9Gxf%2FbSffbSPeiePuifPtFxv9Dxv%2FVTvjVUfiza%2FhlqPxFxv1Fxv1ExP1Exv1Ut%2FtTt%2FtExP1Fxf3bRvZExf2YgPiYgPrMVvi6ZPhDxP1Exf1Exf1Exf1uofpDxPxDxfzCW%2FjcSPbcSPePhfqPhvrTTfbUTvipcPmpcvpDxP1Exf1ExP12mvpExP1Exf3aR%2FaGjfqHjvtdsPxDxP1Exf1Dxf1LvfxLvv1Exf1%2Fk%2Ft%2FlPvbSPdDxf1DxPxLvftLvfxLvvxTtvtUt%2Fxbr%2Ftcr%2FtcsPtkqPpkqPtlqPtlqftsofptofptovt1mvp1m%2Fp2m%2Fp9k%2Fl%2Bk%2Fp%2BlPqGjPmGjPqGjfqHjfqOhfmPhfmPhvmPhvqXfviXfvmXf%2FmYf%2Fmfd%2Figd%2FigePmocPiocfipcfmwafewafixafixavi4Yve5Yve5Y%2FjBW%2FfCW%2FfCXPfCXPjJVPbKVPbKVPfKVffSTfbSTvfTTvcWkpKnAAAATnRSTlMAAQIEBQYGCQsPERMcHSwxOz4%2FQEJCQ0hISEpYZ291eIaHi42OkpKSlZeYmZ6mqa6vuMvLzc3Q0NPT1NfZ4eLl5ujo6e%2Fw9vj4%2Bfn5%2Bf4Ap2wWAAAB8ElEQVQ4y31QiULTQBBdqCKHNx4I3qKAIgreKIKCt10S2rShB9A00ja2SFI0hja2KG1%2Fm5lszlp9Ozu7783s7swSQnoJgMIUYgIhqqoSBgpajxAj5Mw2k15QJ0BpP6wfM1JWyqBSN81ayIr1Eef0rJtsrQPU3kVjghDtgY2UzWakT7DRNG1bOwubUL1mmsSFfdLBebzhnMefUwuzDn%2FH8xzP88vL7xmfSiVT6RRacsoSHimFQl75qihK4SFL0XXDQNN199YnzVar%2BTjw8H0SxCV6McB7oYojfgHLCvv4pFXoHZcfZpXTQ47wxhaWbH6M43iOQ3eUCYsxRBTmIhPSqTRaEhwTMlnJAqxMUPLYKDScV5iAv6yqGv42E4ah8Z%2BG%2FsMwhu13p3%2FVzHqtbk67pQ61Go1G8wLpgHv0LvkPTnyAht4e%2F2f8tt3zzc7h%2Fnnq4GVfh%2FipMPUQPvlX%2FAoN4nJb%2FAZtx%2FVA%2FFpkJbICiNgTXOSqLz4SFxOJeFyERYwnRHHV4iNewtz6xtr6GtgGOiTI57yEVzn5S07GIcubcg4M%2BWsv4VapVCxt4ShuFUvfgCAf8xK6n5bLO9%2FLOzBsA%2Fes29%2FGxG61UqlUwYNVwXYn2j4iNL73Z29%2FH%2BZvdOOhDp%2FdNTg6s%2FB54cHo6S6fegA%2BKLJ63g4njwAAAABJRU5ErkJggg%3D%3D)

This API is intended for use in the Ramsey Mobile Chapter's learning series where they'll create a Lean Coffee app in all mobile frameworks. 

### Things to note

When signing in Authentication is basic.

**Header Example**: `Authorization: Basic Base64Encoded(aladdin:opensesame)`

After that it's bearer token auth


# API Docs

## Entities

|Name|Description|
|:--|:--|
|User| The user who will create lean coffees, topics or votes |
|Lean Coffee| The primary entity that user's will interact with. The Lean Coffee will have many Topic's as children|
|Topic| The topic to be discussed in a lean coffee. This is the child of a Lean Coffee and will have votes as children |
|Vote| A vote is not a "Yay" or "Nay" in the Lean Coffee service. Instead the presence of a vote is indicative of the user's interest in the topic. This is the child of a topic and will have no children|

![Entity Relationship](https://lucid.app/publicSegments/view/d3a417e3-e69e-4999-8933-96eb96bd09bb/image.png)


## Endpoints

<details>
<summary>Create User</summary>
    

### Create User


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

</details>

<details>
<summary>Sign In</summary>

### Sign In

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

</details>

<details>
<summary>Lean Coffee</summary>
    
### Create Lean Coffee 

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

### Get Lean Coffee

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


### Get all topics in a Lean Coffee

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
### Get Lean Coffee Host

*The host is the creator of the lean coffee in the system*

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


### Get all Lean Coffee events

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

</details>

<details>
<summary>Topics</summary>
    
### Create Topic

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

### Get Topic

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

### Complete Topic

*The only way to update a topic (currently) and mark it as complete.*

**POST** `{{URL}}/api/topics/{{topic_id}}/complete`


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
    "completed": true,
    "description": ""
}
```

### Get Topic Introducer

*The introducer is the user who created the topic in a lean coffee*

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

### Get Topic Votes

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

</details>

<details>
<summary>Vote</summary>

### Cast vote

*This must be unique per topic and user. If a user tries to vote twice on a topic, the server will return a conflict.*

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

</details>