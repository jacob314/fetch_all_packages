package com.example.photoprovider

import android.graphics.drawable.Drawable
import com.bumptech.glide.request.Request
import com.bumptech.glide.request.target.SizeReadyCallback
import com.bumptech.glide.request.target.Target

abstract class CustomTarget<T>(private val width: Int, private val height: Int): Target<T> {
    private var request: Request? = null
    override fun getSize(cb: SizeReadyCallback) {
        cb.onSizeReady(width, height)
    }

    override fun onStart() {
        // Intentionally empty, this can be optionally implemented by subclasses.
    }

    override fun onStop() {
        // Intentionally empty, this can be optionally implemented by subclasses.
    }

    override fun onDestroy() {
        // Intentionally empty, this can be optionally implemented by subclasses.
    }

    override fun onLoadStarted(placeholder: Drawable?) {
        // Intentionally empty, this can be optionally implemented by subclasses.
    }

    override fun onLoadFailed(errorDrawable: Drawable?) {
        // Intentionally empty, this can be optionally implemented by subclasses.
    }

    override fun removeCallback(cb: SizeReadyCallback) {
        // Do nothing, this class does not retain SizeReadyCallbacks.
    }

    override fun setRequest(request: Request?) {
        this.request = request
    }

    override fun getRequest(): Request? {
        return request
    }
}