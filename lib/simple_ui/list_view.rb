require_relative 'core'

module SimpleUi::ListView
  def truncate_text(str, max_size: 50)
    raise ArgumentError, 'max_size must be positive' if max_size.negative?
    res = str.dup
    if str.size > max_size
      str_size = [str.size, max_size].min
      res[str_size-3..] = '...'
    end
    res
  end


  # todo: truncate long text
  def list_view(column, format_str, format_args)
    raise ArgumentError unless Array === format_args
    ret = column << "\n"
    format_args.each do |arg|
      str = format(format_str, *arg)
      ret << str << "\n"
    end
    ret
  end
end
