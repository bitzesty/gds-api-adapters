require 'gds_api/base'
require 'rack/utils'

module GdsApi
  class Rummager < Base

    def search(query, extra_params={})
      raise ArgumentError.new("Query cannot be blank") if query.nil? || query.strip.empty?
      get_json!(search_url(:search, query, extra_params))
    end

    def unified_search(args)
      request_url = "#{base_url}/unified_search.json?#{Rack::Utils.build_nested_query(args)}"
      get_json!(request_url)
    end

    def advanced_search(args)
      raise ArgumentError.new("Args cannot be blank") if args.nil? || args.empty?
      request_path = "#{base_url}/advanced_search?#{Rack::Utils.build_nested_query(args)}"
      get_json!(request_path)
    end

    def organisations
      get_json!("#{base_url}/organisations")
    end

    def add_document(type, id, document)
      post_json!(
        documents_url,
        document.merge(
          _type: type,
          _id: id,
        )
      )
    end

    def delete_document(type, id)
      delete_json!(
        "#{documents_url}/#{id}",
        _type: type,
      )
    end

  private

    def search_url(type, query, extra_params={})
      request_path = "#{base_url}/#{type}?q=#{CGI.escape(query)}"
      if extra_params
        request_path << "&"
        request_path << Rack::Utils.build_query(extra_params)
      end
      request_path
    end

    def base_url
      endpoint
    end

    def documents_url
      "#{base_url}/documents"
    end
  end
end
