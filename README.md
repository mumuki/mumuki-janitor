[![Build Status](https://travis-ci.org/mumuki/mumuki-office.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-office)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-office/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-office)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-office/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-office)
[![Issue Count](https://codeclimate.com/github/mumuki/mumuki-office/badges/issue_count.svg)](https://codeclimate.com/github/mumuki/mumuki-office)

Mumuki Office
==============

> Authorization and API Authentication solution for the Mumuki Platform

Mumuki Office is a RESTful service and GUI that allows to

* manage core Mumuki Platform authorization concepts
  * CRUD users and their permissions
  * CRUD organization
  * CRUD courses
* authorize user operations across mumuki applications
* authenticate API clients using JWT tokens

# Sample Flows

## Basic Platform Permissions Setup

1. As a janitor-admin user, log in into janitor
2. Create an organization
3. Create some courses and set subscription mode
   * Use closed subscription mode if you will manually add each student to the course - either by CSV, API or in a one by one basis.
   * Use open subscription mode if you will just share an subscription link among your students.
4. Create some users and teachers
   1. Specify their full name and email - which will be it's primary `uid` -, and zero or more alternative `uid`s
   2. Specify their organizations and courses


## API Client Setup

1. As a janitor-admin user, log into janitor
2. Create a API Secret Token
3. Create a API Client
  1. Set client permissions
  2. Set client logical name
  3. This will generate a private JWT. Use it to authenticate API calls in any Platform application within a `Authorizaion: Bearer <TOKEN>`

# Permissions

Office Permissions are composed of two elements:

* a role, that states which operations a user or API client can perform. Roles are:
  * `student`: 
    * they can solve exercises in Atheneum
  * `teacher`: 
    * same permissions as `student` and
    * enter the classroom
    * see student progress
    * comment solutions
    * follow students
    * create exams
  * `headmaster`
    * same permissions as `teacher` and
    * add more teachers to courses
  * `writer`
    * create content in the editor
  * `editor`
    * same permissions as `writer` and
    * destoy content
  * `janitor`
    * same permissions as `headmaster` and
    * enter this Office application
    * can create users and courses and assign permissions equal or lower to herself
  * `owner`
    * same permissions as `janitor` and `editor`, and
    * can create organizations   
  * Take a look to [the permissions hierarchy](https://yuml.me/diagram/plain/class/[Owner]%5E-[Janitor],%20[Janitor]%5E-[Headmaster],%20[Headmaster]%5E-[Teacher],%20[Teacher]%5E-[Student],%20,%20[Owner]%5E-[Editor],%20[Editor]%5E-[Writer])
  
* a scope, that states in which context the operation can be performed. Scopes are always expressed with a slug, that allows `primary-scope/secondary-scope` you specify are most two-level scopes.

## Scopes details

Scopes are simply two-level contexts, without any explicit semantic. They exact meaning is set by each role:

* student: `organization/course`
* teacher and headmaster: `organization/course`
* writer and editor: `organization/content`
* janitor: `organization/_`
* owner: `_/_`

# API

## Users

### Create single user

This is a generic user creation request.

**Minimal permission**: `janitor`

```
POST /users
```

Sample request body:

```json
{
  "first_name": "María",
  "last_name": "Casas",
  "email": "maryK345@foobar.edu.ar",
  "uids": [],
  "permissions": {
     "student": "cpt/*:rte/*",
     "teacher": "ppp/2016-2q"
  }
}
```

### Update single user

This is a way of updating user basic data. Permissions are ignored.

**Minimal permission**: `janitor`

```
PUT /users/:uid
```

Sample request body:

```json
{
  "first_name": "María",
  "last_name": "Casas",
  "email": "maryK345@foobar.edu.ar"
}
```

### Add student to course

Creates the student if necessary, and updates her permissions.

**Minimal permission**: `janitor`

```
POST /courses/:organization/:course/students
```

```json
{
  "first_name": "María",
  "last_name": "Casas",
  "email": "maryK345@foobar.edu.ar",
  "uids": []
}
```

### Add teacher to course

Creates the teacher if necessary, and updates her permissions.

**Minimal permission**: `headmaster`, `janitor`

```
POST /course/:id/teachers
```

```json
{
  "first_name": "Erica",
  "last_name": "Gonzalez",
  "email": "egonzalez@foobar.edu.ar",
  "uids": []
}
```

### Add a batch of users to a course

Creates every user if necesssary, an updates permissions.

**Minimal permission**: `janitor`

```
POST /course/:id/batches
```

```json
{
  "students": [
    {
      "first_name": "Tupac",
      "last_name": "Lincoln",
      "email": "tliconln@foobar.edu.ar",
      "uids": ["tupac.lincoln@gugel.com"]
    }
  ],
  "teachers": [
    {
      "first_name": "Erica",
      "last_name": "Gonzalez",
      "email": "egonzalez@foobar.edu.ar",
      "uids": []
    }
  ]
}
```

### Detach student from course

**Minimal permission**: `janitor`

```
DELETE /course/:id/students/:uid
```

### Detach teacher from course

**Minimal permission**: `janitor`

```
DELETE /course/:id/teachers/:uid
```

### Destroy single user

**Minimal permission**: `owner`

```
DELETE /users/:uid
```

## Courses

### Create single course

**Minimal permission**: `janitor`

```
POST /organization/:id/courses/
```

```json
{
   "name":"....",
   "subscription_mode": "open"
}
```

### Archive single course

**Minimal permission**: `janitor`

```
DELETE /organization/:id/courses/:id
```

### Destroy single course

**Minimal permission**: `owner`

```
DELETE /courses/:id
```



## Organizations

### List all organizations

```
get /organizations
```

Sample response body:

```json
{
  "organizations": [
    {"name": "academy", "logo_url":"http://...", "private": false},
    {"name": "alcal", "private": true}
  ]
}
```

### Get single organization by name

```
get /organizations/:name
```
Sample response body:

```json
{
  "name":"academy",
  "logo_url":"http://...",
  "private": false,
  "description": "...",
  "book_slug": "MumukiProject/mumuki-libro-metaprogramacion",
  "contact_email": "issues@mumuki.org",
  "login_methods": ["twitter", "facebook", "google"]
}
```

### Organization CSS theme

```
get /themes/:name
```
Sample response body:

```css
a { color: red; }
```


