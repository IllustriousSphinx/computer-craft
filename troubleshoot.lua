-- troubleshoot.lua
print("=== TROUBLESHOOTING GUIDE ===")

-- Step 1: Check HTTP
print("Step 1: Checking HTTP API...")
if http then
    print("✓ HTTP API is available")
else
    print("✗ HTTP API is DISABLED")
    print("  Fix: Enable HTTP in your ComputerCraft config")
    print("  File: config/computercraft-server.toml")
    print("  Set: http.enabled = true")
    return
end

-- Step 2: Test simple HTTP
print("\nStep 2: Testing simple HTTP...")
local success = false
http.request("http://httpbin.org/get")
local timer = os.startTimer(5)

while true do
    local event, url, response, error = os.pullEvent()
    if event == "http_success" then
        print("✓ Basic HTTP works")
        response.close()
        success = true
        break
    elseif event == "http_failure" then
        print("✗ Basic HTTP failed: " .. tostring(error))
        break
    elseif event == "timer" then
        print("✗ Basic HTTP timed out")
        break
    end
end

if not success then
    print("Cannot proceed - basic HTTP doesn't work")
    return
end

-- Step 3: Test your website
print("\nStep 3: Testing your website...")
print("Make sure to replace 'your-website-url.com' with your actual URL!")

local yourUrl = "https://v0-computercraft-website.vercel.app/api/data"
print("URL: " .. yourUrl)

http.request(yourUrl, '{"source":"test","type":"test","data":{"test":true}}', {["Content-Type"] = "application/json"})
timer = os.startTimer(10)

while true do
    local event, url, response, error = os.pullEvent()
    if event == "http_success" and url == yourUrl then
        print("✓ Your website works!")
        print("Response: " .. response.readAll())
        response.close()
        break
    elseif event == "http_failure" and url == yourUrl then
        print("✗ Your website failed: " .. tostring(error))
        print("  Check: Is the URL correct?")
        print("  Check: Is your website running?")
        print("  Check: Does your website accept HTTPS?")
        break
    elseif event == "timer" then
        print("✗ Your website timed out")
        print("  This usually means the URL is wrong or unreachable")
        break
    end
end

print("\nTroubleshooting complete!")
