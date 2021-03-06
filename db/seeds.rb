User.create! email: 'sample@mumuki.org',
             first_name: 'admin',
             last_name: 'admin',
             permissions: {owner: '*'} if Rails.env.development?

Organization.create! name: 'base',
                     description: 'Base organization',
                     contact_email: 'info@mumuki.org',
                     public: true,
                     books: ['mumuki/mumuki-libro-programacion'],
                     login_methods: ['facebook', 'twitter', 'google', 'github'],
                     locale: 'es-AR',
                     logo_url: 'http://mumuki.io/logo-alt-large.png',
                     terms_of_service: '',
                     theme_stylesheet: '',
                     extension_javascript: ''
