# app/helpers/text_helper.rb

module TextHelper
  def humanize_list items, **options
    SleepingKingStudios::Tools::EnumerableTools.humanize_list items, options
  end # method humanize_list
end # module
