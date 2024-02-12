local ok, mirror = pcall(require, "github-mirror")
if not ok then
  return "https://github.com/"
end
return mirror
