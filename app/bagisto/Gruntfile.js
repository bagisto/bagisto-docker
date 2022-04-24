module.exports = function (grunt) {

    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        composer: grunt.file.readJSON('composer.json'),
        phpcs: {
            application: {
                src: ['src/**/*.php', 'tests/**/*.php']
            },
            options: {
                bin: 'vendor/bin/phpcs',
                standard: 'PSR2'
            }
        },
        phpcbf: {
            application: {
                src: ['src/**/*.php', 'tests/**/*.php']
            },
            options: {
                bin: 'vendor/bin/phpcbf',
                standard: 'PSR2',
                noPatch: false
            }
        },
        phpunit: {
            classes: {
                dir: 'tests'
            },
            options: {
                bin: 'vendor/bin/phpunit',
                // testSuffix: "BasicRetryHandlerTest.php",
                staticBackup: false,
                colors: true,
                followOutput: true,
                noGlobalsBackup: false
            }
        }
    });

    grunt.loadNpmTasks('grunt-phpunit');
    grunt.loadNpmTasks('grunt-phpcs');
    grunt.loadNpmTasks('grunt-phpcbf');

    grunt.registerTask('default', ['phpcs', 'phpunit']);
};