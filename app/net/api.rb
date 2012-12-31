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
      if not query.nil?
        query = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        get "#{@base_url}/users/search/json?q=#{query}", user_mapping, block
      end
    end

    # Get favourite track list for the provided user
    def get_user_favorites(id, block)

    end

    def get_track(id, block)

    end

    # opts: :artist => artist name exactly
    #       :track  => track name exactly
    #       :query  => search string
    #       If :query is provided, :artist and :track are ignored.
    def search_track(opts = {}, block)
      if opts.is_a? String
        query = opts
      else
        query = opts[:query]
        artist = opts[:artist]
        track = opts[:track]
      end
      if not query.nil?
        query = query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        get "#{@base_url}/tracks/search/json?q=#{query}", track_mapping, block
      elsif not artist.nil? and not track.nil?
        artist = artist.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        track = track.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        get "#{@base_url}/tracks/search/exact/json?artist=#{artist}&track=#{track}", track_mapping, block
      end
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
      p "performing get: #{path}"
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
        set_user_mapping_attributes(mapping)
        my_track_mapping = RKObjectMapping.mappingForClass(Track)
        set_track_mapping_attributes(my_track_mapping)
        my_playlist_mapping = RKObjectMapping.mappingForClass(Playlist)
        set_playlist_mapping_attributes(my_playlist_mapping)
        mapping.mapKeyPath('tracks', toRelationship:'tracks', withMapping:my_track_mapping)
        mapping.mapKeyPath('playlists', toRelationship:'playlists', withMapping:my_playlist_mapping)
        mapping
      end
    end

    def playlist_mapping
      @playlist_mapping ||= begin
        mapping = RKObjectMapping.mappingForClass(Playlist)
        set_playlist_mapping_attributes(mapping)
        my_track_mapping = RKObjectMapping.mappingForClass(Track)
        set_track_mapping_attributes(my_track_mapping)
        my_user_mapping = RKObjectMapping.mappingForClass(User)
        set_user_mapping_attributes(my_user_mapping)
        mapping.mapKeyPath('tracks', toRelationship:'tracks', withMapping:my_track_mapping)
        mapping.mapKeyPath('author', toRelationship:'author', withMapping:my_user_mapping)
        mapping
      end
    end

    def track_mapping
      @track_mapping ||= begin
        mapping = RKObjectMapping.mappingForClass(Track)
        set_track_mapping_attributes(mapping)
        my_user_mapping = RKObjectMapping.mappingForClass(User)
        set_user_mapping_attributes(my_user_mapping)
        mapping.mapKeyPath('artist', toRelationship:'artist', withMapping:my_user_mapping)
        mapping
      end
    end

    def set_user_mapping_attributes(mapping)
      mapping.mapAttributesFromArray(['id', 'name', 
        'html_description', 'link'])
      mapping.mapKeyPath('description', toAttribute: 'detail')
    end

    def set_playlist_mapping_attributes(mapping)
      mapping.mapAttributesFromArray(['id', 'name', 
        'html_description', 'link'])
      mapping.mapKeyPath('description', toAttribute: 'detail')
    end

    def set_track_mapping_attributes(mapping)
      mapping.mapAttributesFromArray(['id', 'title', 
        'html_description', 'link', 'download'])
      mapping.mapKeyPath('description', toAttribute: 'detail')
    end

  end
end