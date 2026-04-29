package com.omnilab.micrm.config.adapter

import com.google.gson.*
import com.google.gson.reflect.TypeToken
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonWriter
import java.io.IOException

class EmptyStringTypeAdapterFactory : TypeAdapterFactory {
    override fun <T> create(gson: Gson, type: TypeToken<T>): TypeAdapter<T> {
        val delegate: TypeAdapter<T> = gson.getDelegateAdapter(this, type)
        return object : TypeAdapter<T>() {
            @Throws(IOException::class)
            override fun write(out: JsonWriter, value: T) {
                val tree = delegate.toJsonTree(value)
                if (tree.isJsonObject) {
                    val obj = tree.asJsonObject
                    val iterator = obj.entrySet().iterator()
                    while (iterator.hasNext()) {
                        val entry = iterator.next()
                        val v = entry.value
                        if (v.isJsonNull) {
                            iterator.remove()
                            continue
                        }
                        if (v.isJsonPrimitive && v.asJsonPrimitive.isString) {
                            if (v.asString.trim().isEmpty()) {
                                iterator.remove()
                            }
                        }
                    }
                    gson.toJson(obj, out)
                } else {
                    gson.toJson(tree, out)
                }
            }
            override fun read(`in`: JsonReader): T {
                return delegate.read(`in`)
            }
        }
    }
}