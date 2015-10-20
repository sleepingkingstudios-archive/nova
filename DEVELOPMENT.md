# Upcoming Features

## Upkeep ONGOING

## Publishing DONE

## Blog Post Orderings DONE

## Settings DONE

## Icon Helpers DONE

## Preview Features DONE

## Import-Export Features

- Directory#directories, #features should return in ascending alphabetical order. DONE
- Isolate "serializer" behavior from "exporter" behavior! DONE
  - serialize(object) => converts object to hash DONE
  - deserialize(object[, type: type]) => converts hash to object DONE
- Implement Exporter process object. DONE
  - export(object[, format: format]) => converts object to serialized string DONE
  - import(string[, format: format][, type: type]) => converts serialized string to object DONE
- Extract specific decorators from DecoratorsHelper, e.g. #present is defined in PresentersHelper. DONE
- Implement export() helper. DONE
- Implement RootDirectory null object. DONE
  - Support DirectorySerializer.serialize(root_directory) DONE
- Ensure serialize(DirectoryFeature) includes Directory path unless serialized as embedded DONE
- Add controller actions for #import, #export.
- Replace Form with Serializer#deserialize?

## Breadcrumb Navigation

## Cache Page Lookups

- Redis?

# Long-term Features

## Redirect Feature

- When user visits URL, is redirected to other url.

## Implement Liquid filters for contents

## Feature Events

- Created, Updated, Published
- embedded_in :feature
- belongs_to :user

## I18n

- Implement I18n for display strings.

## User Authorization

- Using Pundit? # https://github.com/elabs/pundit

## Custom Collections

## Heritable Settings

## Cached Settings

# Refactoring

- Refactor Directory#parent to #parent_directory
- Refactor Directory#children to #child_directories
- Refactor DirectoryFeature#directory to #parent_directory

## Controller Strategies

- General rename of "Delegate" to ActionController::Strategy subclass.

## Break Features out into First-Class Rails Citizens

- app
  - features
    - blogs.rb
    - blogs
      - config
        - routes.rb
      - controllers
        - strategies
          - blog_strategy.rb
          - blog_post_strategy.rb
      - models
        - blog.rb
        - blog_post.rb
      - presenters
        - blog_presenter.rb
        - blog_post_presenter.rb
      - routers
        ...
    - pages.rb
    - pages
      ...

## Refactor Loading of Content Forms (inline and hide?)
