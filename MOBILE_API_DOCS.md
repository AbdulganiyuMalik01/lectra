# Mobile Timetable API Documentation

## Endpoint

`GET /api/mobile/timetable.php`

Returns the timetable for a specific department and week. This endpoint is used by the mobile application to load and refresh timetable information.

⸻

## Authentication

A valid JWT token is required.

## Header

Authorization: Bearer <token>

⸻

## Query Parameters

Parameter	     Type	 Required	Description
department_id	Integer	  Yes     	Department ID used to filter timetable records
week	        Integer	  Yes     	Academic week number

⸻

## Example Request
G
`GET {{baseUrl}}/api/mobile/timetable.php?department_id=1&week=1`

⸻

## Success Response

`Status Code: 200 OK`

```json
{
    "status": "success",
    "count": 3,
    "data": [
        {
            "id": 1,
            "course_id": 1,
            "day": "Monday",
            "start_time": "09:00:00",
            "end_time": "11:00:00",
            "venue": "Room 101",
            "week": 1,
            "created_at": "2026-06-03 08:05:58",
            "course_code": "CS101",
            "course_title": "Introduction to Programming",
            "department_name": "Computer Science",
            "lecturer_name": "Dr. Jane Smith",
            "lecturer_email": "lecturer@lecktra.edu"
        }H
    ]
}
```
⸻

## Error Responses

## Missing Parameters

`Status Code: 400 Bad Request`

```json
{
  "status": "error",
  "message": "department_id and week are required"
}
```

## Department Not Found

Status Code: 404 Not Found

{
  "status": "error",
  "message": "Department not found"
}

## Unauthorized

Status Code: 401 Unauthorized

{
  "status": "error",
  "message": "Unauthorized"
}

## Invalid Request Method

Status Code: 405 Method Not Allowed

{
  "status": "error",
  "message": "Only GET method is allowed"
}

⸻

## Notes

* Only the GET method is supported.
* department_id and week are required query parameters.
* A valid JWT token must be provided.
* Results are filtered by department and week.
* Timetable entries are returned in ascending order of day and start time.