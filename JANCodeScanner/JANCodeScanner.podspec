Pod::Spec.new do |spec|

  spec.name         = "JANCodeScanner"
  spec.version      = "1.0.1"
  spec.summary      = "JANCode Scanner Pod for Scan JANCode"
  spec.description  = "This Framework is for Scan JANCode and you can use it for getting the JANCode Scan"
  spec.homepage     = "https://github.com/saeedCodium/JANCodeScanner"
  spec.license      = "MIT"
  spec.author             = { "SaeedRahmatolahi" => "saeed.r@codium.co" }
  spec.social_media_url   = "https://www.instagram.com/saeedrahmatolahi_official/?hl=en"
  spec.platform     = :ios, "9.0"
  spec.swift_version = "5.0"
  spec.source       = { :git => "https://github.com/saeedCodium/JANCodeScanner.git", :tag => "1.0.1" }
  spec.source_files  = "JANCodeScanner/**/*.{h,m, swift}"
  
end
