Time::DATE_FORMATS.merge!(
  :display => lambda {|time| time.strftime "%B #{time.day.ordinalize}, %Y at %l:%M %P %Z"}
)