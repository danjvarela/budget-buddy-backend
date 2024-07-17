module StringSearchable
  extend ActiveSupport::Concern

  def search_from(attribute, relation)
    attr_sym = :"#{attribute}_contains"
    opts = params.permit(attr_sym)

    relation.ransack("#{attribute}_i_cont" => opts[attr_sym]).result(distinct: true)
  end
end
