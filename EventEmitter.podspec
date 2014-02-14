Pod::Spec.new do |s|
  s.name         = "EventEmitter"
  s.version      = "0.0.3"
  s.summary      = "An event emitter implementation for Objective-C with dynamic block invocation based on the node.js EventEmitter API."
  s.homepage     = "https://github.com/seegno/EventEmitter"
  s.author       = "Nuno Sousa"
  s.license      = "MIT License"
  s.source_files = "EventEmitter/*.{h,m}"
  s.requires_arc = true

  s.dependency 'BlocksKit/DynamicDelegate', '~> 2.0.0'
  s.dependency 'SLObjectiveCRuntimeAdditions', '~> 1.1.2'
end
