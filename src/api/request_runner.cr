require "../config"

class RequestRunner 
  include JSON::Serializable
  
  property id : String

  property params : Hash(String, String)

  def run(work : Work)
    validate(work)
  end

  def validate(work : Work)
    work.params.map do |p|
      if(@params.has_key?(p.name))
        value = p.typeParam.parser(@params[p.name])
      else
        raise "#{p.name} é obrigatório" if p.required
      end   
    end
  end  
end