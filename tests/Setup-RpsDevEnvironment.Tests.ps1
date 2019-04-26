$here = Split-Path -Parent $MyInvocation.MyCommand.Path 
$base = Split-Path -Parent $here
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$base\src\$sut"

Describe "RPS Dev Helper Functions" {
    
    class fake_webclient 
    {
        [void] DownloadFile($url, $location) { }
    }

    Mock 'New-Object' { New-Object 'fake_webclient' } `
        -Verifiable `
        -ParameterFilter { $TypeName -and ($TypeName -ilike 'Net.WebClient') } 
        

    Context "getVswhereUrlFromGithub" {
        $jsonResult = '{
            "url": "https://api.github.com/repos/Microsoft/vswhere/releases/15270169",
            "assets_url": "https://api.github.com/repos/Microsoft/vswhere/releases/15270169/assets",
            "upload_url": "https://uploads.github.com/repos/Microsoft/vswhere/releases/15270169/assets{?name,label}",
            "html_url": "https://github.com/Microsoft/vswhere/releases/tag/2.6.7",
            "id": 15270169,
            "node_id": "MDc6UmVsZWFzZTE1MjcwMTY5",
            "tag_name": "2.6.7",
            "target_commitish": "91f4c1d09e2a88340fb30225798c0ce14f43b99d",
            "name": null,
            "draft": false,
            "author": {
              "login": "heaths",
              "id": 1532486,
              "node_id": "MDQ6VXNlcjE1MzI0ODY=",
              "avatar_url": "https://avatars1.githubusercontent.com/u/1532486?v=4",
              "gravatar_id": "",
              "url": "https://api.github.com/users/heaths",
              "html_url": "https://github.com/heaths",
              "followers_url": "https://api.github.com/users/heaths/followers",
              "following_url": "https://api.github.com/users/heaths/following{/other_user}",
              "gists_url": "https://api.github.com/users/heaths/gists{/gist_id}",
              "starred_url": "https://api.github.com/users/heaths/starred{/owner}{/repo}",
              "subscriptions_url": "https://api.github.com/users/heaths/subscriptions",
              "organizations_url": "https://api.github.com/users/heaths/orgs",
              "repos_url": "https://api.github.com/users/heaths/repos",
              "events_url": "https://api.github.com/users/heaths/events{/privacy}",
              "received_events_url": "https://api.github.com/users/heaths/received_events",
              "type": "User",
              "site_admin": false
            },
            "prerelease": false,
            "created_at": "2019-01-30T10:26:18Z",
            "published_at": "2019-01-30T16:25:08Z",
            "assets": [
              {
                "url": "https://api.github.com/repos/Microsoft/vswhere/releases/assets/10851190",
                "id": 10851190,
                "node_id": "MDEyOlJlbGVhc2VBc3NldDEwODUxMTkw",
                "name": "vswhere.exe",
                "label": "",
                "uploader": {
                  "login": "heaths",
                  "id": 1532486,
                  "node_id": "MDQ6VXNlcjE1MzI0ODY=",
                  "avatar_url": "https://avatars1.githubusercontent.com/u/1532486?v=4",
                  "gravatar_id": "",
                  "url": "https://api.github.com/users/heaths",
                  "html_url": "https://github.com/heaths",
                  "followers_url": "https://api.github.com/users/heaths/followers",
                  "following_url": "https://api.github.com/users/heaths/following{/other_user}",
                  "gists_url": "https://api.github.com/users/heaths/gists{/gist_id}",
                  "starred_url": "https://api.github.com/users/heaths/starred{/owner}{/repo}",
                  "subscriptions_url": "https://api.github.com/users/heaths/subscriptions",
                  "organizations_url": "https://api.github.com/users/heaths/orgs",
                  "repos_url": "https://api.github.com/users/heaths/repos",
                  "events_url": "https://api.github.com/users/heaths/events{/privacy}",
                  "received_events_url": "https://api.github.com/users/heaths/received_events",
                  "type": "User",
                  "site_admin": false
                },
                "content_type": "application/x-msdownload",
                "state": "uploaded",
                "size": 458336,
                "download_count": 16299,
                "created_at": "2019-01-30T16:25:09Z",
                "updated_at": "2019-01-30T16:25:09Z",
                "browser_download_url": "https://github.com/Microsoft/vswhere/releases/download/2.6.7/vswhere.exe"
              }
            ],
            "tarball_url": "https://api.github.com/repos/Microsoft/vswhere/tarball/2.6.7",
            "zipball_url": "https://api.github.com/repos/Microsoft/vswhere/zipball/2.6.7",
            "body": "\n\n## Changes:\n\n* 91f4c1d09e2a88340fb30225798c0ce14f43b99d Merge pull request #173 from Microsoft/develop\n* d9dbe79db33784e9fd3032f40eae8a01aa088610 Fix special directory references to -find [ #171 ]\n* a76aad23dd3f41a0f3cc2696af40741a227bb4d2 Add chocolatey to agent demands\n* e6edc722d056c7dee2b246969145aed37c94fc8d Update badges for readability in README\n* 7446fa5c48b5b286de564934bfcf6a133d8dc80a Use build number for release notes URL [ #169 ]\n* f078b21784b53dd811ad72f0334b7b70f22aa9cf Escape quotes and backslashes for JSON\n* 93e638e4a8f373f011e2a7455ac346cc80565cfa Bump minor version number\n* 066918c7f51dcfeb4d3ea9e897fdb21d5e24aa32 Add -find switch to search files in root [ #162 ]\n* 64fe6e95aee9c4a44c255354ec2ab9c85910459c Add support for sorting instances\n* 0d92cf1f7a432228974b1ff51a6163fbc0c25c47 Expose IsRebootRequired property\n<details><summary><b>See more</b></summary>\n\n* c021cdba3cea89d3870be8cac52f3c317fac0754 Build and published signed prereleases\n\nThis list of changes was [auto generated](https://devdiv.visualstudio.com/0bdbc590-a062-4c3f-b0f6-9383f67865ee/_release?releaseId=243498&_a=release-summary).</details>"
          }'

        Mock Invoke-WebRequest { return @{ Content = $jsonResult } }
        It "should return the correct download url" {
            $expected = "https://github.com/Microsoft/vswhere/releases/download/2.6.7/vswhere.exe"
            $actual = getVswhereUrlFromGithub

            $actual | Should -BeExactly $expected
        }
    }

    Context "getVswhereFromGithub" {
 
        It "should download the vswhere location to the correct folder" {
            $vsWhereUrl = "someurl"

            $actual = getVswhereFromGithub -VswhereUrl $vsWhereUrl -TempFolderLocation "c:\tempfolder"

            Assert-MockCalled New-Object 
            $actual | Should -Be "c:\tempfolder\vswhere.exe"
        }
    }  

    Context "getVisualStudioGitLocation" {
        Mock Start-Process { return "c:\location\to\vs" }
        it "should execute vswhere and return the path to git" {
            $expected = "c:\location\to\vs\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git"
            
            $actual = getVisualStudioGitLocation -VswhereExeLocation "c:\temp\vswhere.exe"

            $actual | Should -be $expected
        }
    }

    Context "getDodInstallRootInstaller" {
        it "should return the download location of the InstallRoot application" {
            $expected = "TempDrive:\temp\InstallRoot\InstallRoot_5.2x32_NonAdmin.msi"
            $actual = getDodInstallRootInstaller -TempFolderLocation "TestDrive:\temp"

            Assert-MockCalled New-Object 
            $actual | should -be $expected
        }
    }
}