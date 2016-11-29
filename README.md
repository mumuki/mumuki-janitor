# _Proposed_ API

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


