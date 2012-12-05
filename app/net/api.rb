module EQBeats
  API_BASE_URL = 'https://eqbeats.org'

  class API
    attr_accessor :base_url

    def initialize(base_url=API_BASE_URL)
      self.base_url = base_url
      initialize_restkit
      register_eqbeats_mapping
    end

    # Gets a user based on the provided id.
    def get_user(id, block)
      get "#{@base_url}/user/#{id}/json", user_mapping, block
    end

    # Searches for a user based on the provided query.
    def search_user(query, block)

    end

    # Get favourite track list for the provided user
    def get_user_favorites(id, block)

    end

    def get_track(id, block)

    end

    def search_track(opts = {}, block)

    end

    def get_latest_tracks(block)

    end

    def get_featured_tracks(block)

    end

    def get_random_tracks(block)

    end

    def get_playlist(id, block)

    end

    protected
    def get(path, mapping, block)
      object_manager.loadObjectsAtResourcePath path, usingBlock: ->(loader) {
        loader.objectMapping = mapping
        loader.onDidLoadObjects = block
        loader.onDidFailWithError = block
      }
    end

    def initialize_restkit
      RKObjectManager.objectManagerWithBaseURLString(base_url)
    end

    def object_manager
      @object_manager ||= RKObjectManager.sharedManager
    end

    def register_eqbeats_mapping
      object_manager.mappingProvider.setMapping(user_mapping, 
        forKeyPath: 'artist')
      object_manager.mappingProvider.setMapping(user_mapping, 
        forKeyPath: 'author')
      object_manager.mappingProvider.setMapping(playlist_mapping, 
        forKeyPath: 'playlists')
      object_manager.mappingProvider.setMapping(track_mapping,
        forKeyPath: 'tracks')
      object_manager.mappingProvider.addObjectMapping(user_mapping)
      object_manager.mappingProvider.addObjectMapping(playlist_mapping)
      object_manager.mappingProvider.addObjectMapping(track_mapping)
    end

    def user_mapping
      @user_mapping ||= begin
        mapping = RKObjectMapping.mappingForClass(User)
        mapping.mapAttributesFromArray(['id', 'name', 
          'html_description', 'link'])
        mapping.mapKeyPath('description', toAttribute: 'detail')
      end
    end

    def playlist_mapping
      @playlist_mapping ||= begin
        mapping = RKObjectMapping.mappingForClass(Playlist)
        mapping.mapAttributesFromArray(['id', 'name', 
          'html_description', 'link'])
        mapping.mapKeyPath('description', toAttribute: 'detail')
      end
    end

    def track_mapping
      @track_mapping ||= begin
        mapping = RKObjectMapping.mappingForClass(Track)
        mapping.mapAttributesFromArray(['id', 'title', 
          'html_description', 'link,' 'download'])
        mapping.mapKeyPath('description', toAttribute: 'detail')
      end
    end

  end
end