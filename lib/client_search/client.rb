class Client
  attr_reader :id, :full_name, :email

  def initialize(id, full_name, email)
    @id = id
    @full_name = full_name
    @email = email
  end

  def to_s = "#{full_name} (#{id}) <#{email}>"

  def self.from(hash: )
    return nil if hash.nil?
    Client.new(
      hash['id']&.to_i,
      hash['full_name'],
      hash['email']
    )
  end
end
