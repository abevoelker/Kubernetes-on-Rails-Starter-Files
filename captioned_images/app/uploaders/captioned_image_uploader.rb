require "image_processing/mini_magick"

class CaptionedImageUploader < Shrine
  plugin :processing
  plugin :versions

  process(:store) do |io, context|
    original = io.download
    pipeline = ImageProcessing::MiniMagick.source(original)
    size_512 = pipeline.resize_to_fill!(512, 512, gravity: "Center")

    {original: io, square: size_512}
  end
end
