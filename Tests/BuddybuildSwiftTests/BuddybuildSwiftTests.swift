import XCTest
import Quick
import Nimble
import Files

@testable import BuddybuildSwift

class BuddybuildSwiftTests: QuickSpec {

    override func spec() {
        var sandbox: Folder!
        beforeEach {
            print("Creating sandbox...")
            sandbox = try! Folder.temporary.createSubfolderIfNeeded(withName: "buddybuild-test")
        }

        afterEach {
            print("Deleting sandbox...")
            try! sandbox.delete()
        }

        describe("Build") {
            var env: Environment!
            beforeEach {
                env = Environment(config: [
                    "BUILD_NUMBER": "12",
                    "BUILD_ID": "a8dhfj402ksjdhcjdkeidkelsowldl",
                    "APP_ID": "a8dhfj402ksjdhcjdkeidkelsowldl",
                    "BRANCH": "feature/add-pretty-animations",
                    "BASE_BRANCH": "master",
                    "REPO_SLUG": "buddybuild-public/buddybuild-swift",
                    "PULL_REQUEST": "44",
                    "WORKSPACE": try! sandbox.createSubfolder(named: "workspace").path,
                    "SECURE_FILES": try! sandbox.createSubfolder(named: "secure-files").path,
                    "TRIGGERED_BY": "rebuild_of_commit"
                ])
            }

            it("can be instantiated") {
                expect { try Buddybuild.Build(env: env) }.notTo(throwError())
            }
        }

        describe("Android") {
            context("building an iOS app") {
                var env: Environment!
                beforeEach {

                    env = Environment(config: [
                        "IPA_PATH": try! sandbox.createFile(named: "potato.ipa").path,
                        "APP_STORE_IPA_PATH": try! sandbox.createFile(named: "appStorePotato.ipa").path,
                        "TEST_DIR": "/tmp/workspace/tests-bundle",
                        "SCHEME": "Potato - Debug"
                    ])
                }

                afterEach {
                    env = nil
                }

                it("can't be instantiated") {
                    expect { try Buddybuild.Android(env: env) }.to(throwError())
                }
            }

            context("building and Android app") {
                var env: Environment!
                beforeEach {
                    env = Environment(config: [
                        "APKS_DIR": try! sandbox.createSubfolder(named: "apks").path,
                        "VARIANTS": "release",
                        "ANDROID_HOME": try! sandbox.createSubfolder(named: "android-sdk").path,
                        "ANDROID_NDK_HOME": try! sandbox.createSubfolder(named: "android-ndk").path
                    ])
                }

                it("can be instantiated") {
                    expect { try Buddybuild.Android(env: env) }.notTo(throwError())
                }
            }
        }

        describe("iOS") {
            context("building an iOS app") {
                var env: Environment!

                beforeEach {
                    env = Environment(config: [
                        "IPA_PATH": try! sandbox.createFile(named: "potato.ipa").path,
                        "APP_STORE_IPA_PATH": try! sandbox.createFile(named: "appStorePotato.ipa").path,
                        "TEST_DIR": "/tmp/workspace/tests-bundle",
                        "SCHEME": "Potato - Debug"
                    ])
                }

                it("can be instantiated") {
                    expect { try Buddybuild.IOS(env: env) }.notTo(throwError())
                }
            }

            context("building an Android app") {
                var env: Environment!

                beforeEach {
                    env = Environment(config: [
                        "APKS_DIR": try! sandbox.createSubfolder(named: "apks").path,
                        "VARIANTS": "release",
                        "ANDROID_HOME": try! sandbox.createSubfolder(named: "android-sdk").path,
                        "ANDROID_NDK_HOME": try! sandbox.createSubfolder(named: "android-ndk").path
                    ])
                }

                it("can't be instantiated") {
                    expect { try Buddybuild.IOS(env: env) }.to(throwError())
                }
            }
       }
    }
}
