
<img src="logo.png" style="display: block;margin-left: auto;margin-right: auto"></img>

A static site generator for blogs, written in Dart.

## Example

Start with a normal dart project, and add a `contents` and `templates` folder:
 
    web/
        contents/
        templates/
    pubspec.yaml

and in your pubspec:

    name: my_awesome_blog
    dependencies:
      browser: any
      tavern: any
    transformers:
    - tavern

the `content/` directory can contain markdown files with metadata:

    ---
    title: Hello World!
    category: Random
    tags: ['code', 'dart']
    template: index
    ---

    foo

the `template` will associate that page with a template in the `templates/`
directory.  Templates use Mustache bindings and have access to any metadata
specified in the markdown file.  For example:

```
<html>
<head>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
<div class="content">
    <h1>{{title}}</h1>
    <div id="content">
        {{{content}}}
    </div>
</div>
</body>
</html>
```

## Running and Building

Tavern uses Pub; simply use `pub serve` and `pub build` to test and deploy your
blog.

## Tags

Tavern supports tagging articles and viewing articles associated with that tag:

For an index of tags, add a `tag_index.html` template and use the `tags`
metadata in your template:

    <!--tag_index.html-->
    <ul>
        {{#tags}}
            <li><a href="{{url}}">{{name}}</a></li>
        {{/tags}}
    </ul>

For "tag pages" (To list all pages associated with a tag) add a `tag_page.html`
template and use the `posts` metadata:

    <!--tag_page.html-->
    <ul>
        {{#posts}}
            <li><a href="{{url}}">{{name}}</a></li>
        {{/posts}}
    </ul>



