package com.example.photoprovider

import android.Manifest
import android.annotation.TargetApi
import android.app.Activity
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.os.Build
import android.provider.MediaStore
import com.bumptech.glide.Glide
import io.flutter.plugin.common.MethodChannel.Result
import com.bumptech.glide.request.target.Target
import com.bumptech.glide.request.transition.Transition
import java.io.ByteArrayOutputStream
import java.io.File

import java.util.ArrayList

class PhotoProvider private constructor() {
    companion object {
        val instance: PhotoProvider by lazy(mode = LazyThreadSafetyMode.SYNCHRONIZED) {
            PhotoProvider()
        }
    }
    private val permissions = arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE)
    var activity: Activity? = null
    private var imageList = ArrayList<String>()
    var imageListCount: Int = 0
        get() = imageList.size
    // 获取所有相册图片
    fun init() {
        check(checkPermission())
        val projection = arrayOf(MediaStore.Images.Media.DATA)
        val cursor = MediaStore.Images.Media.query(activity!!.contentResolver,
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                projection,
                null,
                MediaStore.Images.Media.DATE_ADDED)
        imageList.clear()
        if (cursor.count == 0) {
            return
        }
        if (cursor.moveToFirst()) {
            val dataColumn = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            do {
                val data = cursor.getString(dataColumn)
                imageList.add(data)
            } while (cursor.moveToNext())
        }
        cursor.close()
    }

    @TargetApi(Build.VERSION_CODES.M)
    private fun requestPermissions() {
        activity?.requestPermissions(permissions, 1)
    }
    fun checkPermission(): Boolean {
        check(activity != null)
        permissions.forEach {
            if (activity!!.packageManager.checkPermission(it, activity!!.packageName) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions()
                return false
            }
        }
        return true
    }
    fun getImage(index: Int,
                 width: Int?,
                 height: Int?,
                 compress: Int?,
                 result: Result) {
        check(index < imageListCount)
        val loadCompress = compress ?: 80
        Glide.with(activity!!)
                .asBitmap()
                .load(File(imageList[index]))
                .into(object : CustomTarget<Bitmap>(width ?: Target.SIZE_ORIGINAL, height ?: Target.SIZE_ORIGINAL) {
                    override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                        val stream = ByteArrayOutputStream()
                        resource.compress(Bitmap.CompressFormat.JPEG, loadCompress, stream)
                        result.success(stream.toByteArray())
                    }
                    override fun onLoadCleared(placeholder: Drawable?) {
                        result.success(null)
                    }
                })

    }
}