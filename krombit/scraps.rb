module HashFriend
  def +(other)
    s = {}.merge self
    other.each do |key, value|
      if s[key]
        s[key] += value
      else
        s[key] = value
      end
    end
    return s
  end
end

class Hash
  include HashFriend
end