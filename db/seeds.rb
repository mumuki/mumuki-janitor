Organization.create! name: 'base',
                     description: 'Base organization',
                     contact_email: 'info@mumuki.org',
                     public: true,
                     books: ['mumuki/mumuki-libro-programacion'],
                     login_methods: ['facebook', 'twitter', 'google', 'github'],
                     locale: 'es-AR',
                     logo_url: 'http://mumuki.io/logo-alt-large.png',
                     terms_of_service: 'Default terms of service',
                     theme_stylesheet: '.default { css: red }',
                     extension_javascript: 'function defaultJs() {}'

# Don't touch this file - the tests depend on it