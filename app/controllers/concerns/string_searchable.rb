module StringSearchable
  extend ActiveSupport::Concern

  def search_from(attribute, resource)
    attr_sym = :"#{attribute}_contains"
    opts = params.permit(attr_sym)

    resource.ransack("#{attribute}_i_cont" => opts[attr_sym])
  end
end
