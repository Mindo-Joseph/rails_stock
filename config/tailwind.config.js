module.exports = {
  content: [
    './app/views/**/*.{erb,haml,html,slim}',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/components/**/*.{erb,haml,html,slim,rb}',
    './config/initializers/simple_form.rb',
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ]
}
