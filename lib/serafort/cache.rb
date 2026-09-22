# frozen_string_literal: true

module Serafort
  class Cache
    Entry = Struct.new(:value, :expires_at)

    def initialize
      @store = {}
      @mutex = Mutex.new
    end

    def read(key)
      @mutex.synchronize do
        entry = @store[key]
        return nil unless entry

        if entry.expires_at < Time.now.to_i
          @store.delete(key)
          nil
        else
          entry.value
        end
      end
    end

    def write(key, value, ttl: 3600)
      @mutex.synchronize do
        @store[key] = Entry.new(value, Time.now.to_i + ttl)
      end
    end

    def fetch(key, ttl: 3600)
      val = read(key)
      return val if val

      new_val = yield
      write(key, new_val, ttl: ttl)
      new_val
    end

    def clear
      @mutex.synchronize { @store.clear }
    end
  end
end
