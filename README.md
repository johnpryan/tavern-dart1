
<p align="center">
    <img src="logo.png"></img>
</p>

![travis ci build](https://travis-ci.org/johnpryan/tavern.svg)

A static site generator for blogs, written in Dart.

## Features

- [x] Markdown and Mustache templating
- [x] Support for tags and a tag index page.
- [x] Compatibility with dart2js
- [x] Compatibility with other Dart transformers (e.g. Polymer, SASS)
- [x] Support for including a tag list in any page
- [ ] Base URL configuration (similar to [how it works in Jekyll][1])
- [ ] Site, post, and template generation tool
- [ ] Support for configuring post metadata in a separate YAML file
- [x] Support for sitemap.xml and rss/atom
- [ ] Support for multiple languages
- [ ] Support for archived posts

## Examples

See the [examples](/example) folder.

## Getting Started

Start with a normal dart project with the following structure:
 
    web/
      index.md
      templates/
        index.html
    pubspec.yaml

and in your pubspec:

    name: my_awesome_blog
    dependencies:
      browser: any
      tavern: any
    transformers:
    - tavern

In `index.md`, add some metadata and markdown:

    ---
    title: Hello World!
    category: Random
    tags: ['code', 'dart']
    template: index
    ---

    foo

the `templates/index.html` will be associated your page.  Templates use Mustache
bindings and can use any metadata specified in the markdown file.  For example:

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


## Other Transformers (e.g. Polymer)

Tavern leverages Dart's asset transformer, and can be used with other transformers.
It is recommended that other transformers be run *after* Tavern:

```
transformers:
- tavern
- polymer:
    entry_points:
      - web/index.html
```

## Relative Paths / baseurl
Tavern desn't *yet* have support for configuring and updating the base url.  For
now it is recommended to use relative and absolute paths: 

```
<a href="/tags/index.html"</a>
<a href="../../styles.css"</a>
```

Any templates that should assume they are at their final position when
referencing CSS, Dart, JS. For example, `web/templates/index.html` should assume
it has been already moved to the location of the markdown file using it (e.g.
`web/index.md`)



[1]: https://byparker.com/blog/2014/clearing-up-confusion-around-baseurl/
