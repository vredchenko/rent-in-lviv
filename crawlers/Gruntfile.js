module.exports = function(grunt) {

    // Project configuration.
    grunt.initConfig(
    {
        pkg: grunt.file.readJSON('package.json')
    
        //  Watch for changes in js core and lib files and runs jshint if it finds any.
        //
    ,   watch:
        {
            coffee:
            {
                files:
                [
                    "src/**/*.coffee"
                ]
            ,   tasks:
                [
                    "coffee"
                ]
            ,   options:
                {
                    interrupt: true
                }
            }
        }

    ,   coffee:
        {
            compile:
            {
                expand: true
            ,   cwd:    "src"
            ,   src:    [ "**/*.coffee" ]
            ,   dest:   "dest"
            ,   ext:    ".js"
            }
        }
    
    });

    // Load the plugin that provides the "uglify" task.
    // grunt.loadNpmTasks( "grunt-jsdoc"            );
    // grunt.loadNpmTasks( "grunt-requirejs"        );
    // grunt.loadNpmTasks( "grunt-contrib-copy"     );
    // grunt.loadNpmTasks( "grunt-contrib-clean"    );
    grunt.loadNpmTasks( "grunt-contrib-watch"    );
    // grunt.loadNpmTasks( "grunt-contrib-jshint"   );
    // grunt.loadNpmTasks( "grunt-contrib-concat"   );
    // grunt.loadNpmTasks( "grunt-string-replace"   );
    // grunt.loadNpmTasks( "grunt-contrib-compress" );
    grunt.loadNpmTasks( "grunt-contrib-coffee"   );
    // grunt.loadNpmTasks( "grunt-contrib-qunit"    );
    // grunt.loadNpmTasks( "grunt-ftp-deploy"       );
    // grunt.loadNpmTasks( "grunt-contrib-uglify" );

    // Default task(s).
    grunt.registerTask('default',  []);
    grunt.registerTask('sherlock', ["watch:coffee"]);

};
