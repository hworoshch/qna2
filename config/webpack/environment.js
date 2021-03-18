const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: ['popper.js', 'default']
}))

const HandlebarsLoader = {
    test: /\.hbs$/,
    loader: 'handlebars-loader'
}
environment.loaders.append('hbs', HandlebarsLoader)

module.exports = environment
