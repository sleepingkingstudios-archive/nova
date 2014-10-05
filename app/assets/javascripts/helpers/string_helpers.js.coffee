# app/assets/javascripts/helpers/string_helpers.js.coffee

Appleseed.Helpers.StringHelpers = {
  _parameterizeString: (string, separator = '-') =>
    separatorPattern = separator.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&")

    string = string.toLowerCase();
    string = string.replace(/[^a-z0-9\-_]+/g, separator)
    string = string.replace(new RegExp("#{separatorPattern}{2,}", "g"), separator)
    string = string.replace(new RegExp("^#{separatorPattern}"), '')
    string = string.replace(new RegExp("#{separatorPattern}$"), '')
}
