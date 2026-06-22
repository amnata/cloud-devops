# main.py

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

app = FastAPI(
    title="Test FastAPI",
    description="A simple FastAPI test API",
    version="1.0.0"
)

# In-memory database
items = []

# Pydantic model
class Item(BaseModel):
    id: int
    name: str
    price: float


@app.get("/")
def root():
    return {"message": "FastAPI is running!"}


@app.get("/items", response_model=List[Item])
def get_items():
    return items


@app.get("/items/{item_id}", response_model=Item)
def get_item(item_id: int):
    for item in items:
        if item.id == item_id:
            return item
    raise HTTPException(status_code=404, detail="Item not found")


@app.post("/items", response_model=Item)
def create_item(item: Item):
    items.append(item)
    return item


@app.put("/items/{item_id}", response_model=Item)
def update_item(item_id: int, updated_item: Item):
    for index, item in enumerate(items):
        if item.id == item_id:
            items[index] = updated_item
            return updated_item
    raise HTTPException(status_code=404, detail="Item not found")


@app.delete("/items/{item_id}")
def delete_item(item_id: int):
    for index, item in enumerate(items):
        if item.id == item_id:
            deleted = items.pop(index)
            return {"message": "Item deleted", "item": deleted}

    raise HTTPException(status_code=404, detail="Item not found")
