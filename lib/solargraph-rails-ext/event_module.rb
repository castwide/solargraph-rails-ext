module SolargraphRailsExt
  module EventModule
    def post_init
    end

    def receive_data data
      parts = JSON.parse(data)
      result = []
      con = find_constant(parts['namespace'], parts['root'])
      unless con.nil?
        if (parts['scope'] == 'class')
          if parts['with_private']
            result.concat con.methods
          else
            result.concat con.public_methods
          end
        elsif (parts['scope'] == 'instance')
          if parts['with_private']
            result.concat con.instance_methods
          else
            result.concat con.public_instance_methods
          end
        end
      end
      send_data "#{result.to_json}\n"
      close_connection_after_writing
    end

    def unbind
    end

    private

    def find_constant(namespace, root)
      result = nil
      parts = root.split('::')
      if parts.empty?
        result = inner_find_constant(namespace)
      else
        until parts.empty?
          result = inner_find_constant("#{parts.join('::')}::#{namespace}")
          break unless result.nil?
          parts.pop
        end
      end
      result
    end

    def inner_find_constant(namespace)
      cursor = Object
      parts = namespace.split('::')
      until parts.empty?
        here = parts.shift
        begin
          cursor = cursor.const_get(here)
        rescue NameError
          return nil
        end
      end
      cursor
    end
  end
end
