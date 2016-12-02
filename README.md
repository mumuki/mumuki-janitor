Mumuki Janitor
==============

> Authorization and API Authentication solution for the Mumuki Platform

Mumuki Janitor is a RESTful service and GUI that allows to

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
   * User closed subscription mode if you will manually add each student to the course - either by CSV, API or in a one by one basis.
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

Janitor Permissions are composed of two elements: 

* a role, that states which operations a user or API client can perform. Roles are:
  * `student`: they can solve exercises in Atheneum
  * `teacher`: they can
    * enter the classroom
    * see student progress
    * comment solutions
    * follow students
    * create examsn
  * `teacher-admin` (aka `professor`)
    * same permissions as `teacher`  and
    * add more teachers to courses
  * `writer`
    * create content in the editor
  * `writer-admin` (aka `librarian`)
     * same permissions as `writer` and
     * destoy content
  * `janitor`
     * enter this Janitor application
     * can create users and courses and assign permissions equal or lower to herself 
  * `janitor-admin` (aka instance `owner`)
     * same permissions than a `janitor`, and
     * can create organizations 
* a scope, that states in which context the operation can be performed. Scopes are always expressed with a slug, that allows `primary-scope/secondary-scope` you specify are most two-level scopes. 

## Scopes details

Scopes are simply two-level contexts, without any explicit semantic. They exact meaning is set by each role: 

* students: `organization/_`
* teacher and teacher-admin: `organization/course`
* janitor: `organization/_`
* janitor-admin: `_/_`
* writer and writer-admin: `organization/content` 

# API

## Users

## Courses

## Organizations

### List all organizations

```
get /organizations
```

Sample response: 

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
Sample response: 

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
Sample response: 

```css
a { color: red; }
```


