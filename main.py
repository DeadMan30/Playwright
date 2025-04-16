from fastapi import FastAPI, Request
from pydantic import BaseModel
from playwright.async_api import async_playwright

app = FastAPI()

class BypassRequest(BaseModel):
    url: str

@app.post("/bypass")
async def bypass_url(data: BypassRequest):
    url = data.url

    try:
        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True)
            context = await browser.new_context()
            page = await context.new_page()
            await page.goto(url, timeout=60000, wait_until="domcontentloaded")

            # Wait a bit if needed (for JS redirects)
            await page.wait_for_timeout(5000)

            final_url = page.url
            await browser.close()
            return {"success": True, "original": url, "bypassed": final_url}

    except Exception as e:
        return {"success": False, "error": str(e)}
