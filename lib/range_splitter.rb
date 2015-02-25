class Range
  def split(params = {})
    into = params[:into] || 2
    endianness = params[:endianness] || :big

    unless [:big, :little].include?(endianness)
      err = 'The endianness parameter must be either :big or :little'
      raise ArgumentError.new(err)
    end

    if into <= 0
      err = "Cannot split #{self} into #{into} ranges."
      raise ArgumentError.new(err)
    end

    partition    = count / into
    remainder    = count % into
    parts, start = [], 0

    into.times do |index|
      length = partition + (remainder > 0 && remainder > index ? 1 : 0)

      if endianness == :big
        parts << to_a.slice(start, length)
      else
        parts.unshift(to_a.slice(-start-length, length))
      end

      start += length
    end

    parts.select(&:any?).map do |part|
      part.first..part.last
    end
  end
end
