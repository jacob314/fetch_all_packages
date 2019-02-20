package mo.dyna.dropdown

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.os.Handler
import android.os.Looper
import android.util.AttributeSet
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import android.view.animation.TranslateAnimation
import android.widget.FrameLayout
import android.widget.RelativeLayout
import android.widget.TextView

class EZDropdown : FrameLayout
{
    fun setTopPadding(padding: Int)
    {
        this.textView?.setPadding(0, padding, 0, 0)
    }

    fun setText(text: String?)
    {
        this.textView?.text = text
    }

    fun setBackground(color: Int?)
    {
        if(color != null)
        {
            this.dropdownView?.setBackgroundColor(color)
        }
        else
        {
            this.dropdownView?.setBackgroundColor(Color.RED)
        }
    }

    fun setForeground(color: Int?)
    {
        if(color != null)
        {
            this.textView?.setTextColor(color)
        }
        else
        {
            this.textView?.setTextColor(Color.WHITE)
        }
    }

    private var dropdownView: RelativeLayout? = null
    private var textView: TextView? = null

    constructor(context: Context) : super(context)
    {
        this.setup(context)
    }

    constructor(context: Context,
                attrs: AttributeSet) : super(context, attrs)
    {
        this.setup(context)
    }

    constructor(context: Context,
                attrs: AttributeSet,
                defStyleAttr: Int) : super(context, attrs, defStyleAttr)
    {
        this.setup(context)
    }

    fun setup(context: Context)
    {
        this.dropdownView = RelativeLayout(context)
        this.dropdownView?.layoutParams = RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT
        )
        val padding = (10f * resources.displayMetrics.density).toInt()
        this.dropdownView?.setPadding(padding, padding, padding, padding)
        this.dropdownView?.visibility = View.VISIBLE

        this.textView = TextView(context)
        this.textView?.layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.WRAP_CONTENT
        )
        this.textView?.gravity = Gravity.CENTER_HORIZONTAL

        this.dropdownView?.addView(this.textView)
        this.addView(this.dropdownView)

        this.setOnClickListener {
            this.hide()
        }
    }

    override fun onLayout(changed: Boolean,
                          left: Int,
                          top: Int,
                          right: Int,
                          bottom: Int)
    {
        super.onLayout(changed, left, top, right, bottom)
        this.show()
    }

    private fun show()
    {
        val anim = TranslateAnimation(0.0f, 0.0f, -(this.height.toFloat()), 0.0f)
        anim.duration = 300
        anim.setAnimationListener(object : Animation.AnimationListener {
            override fun onAnimationRepeat(animation: Animation?)
            {
            }

            override fun onAnimationEnd(animation: Animation?)
            {
                postDelayed({
                                hide()
                            }, 3000)
            }

            override fun onAnimationStart(animation: Animation?)
            {
            }
        })
        startAnimation(anim)
    }

    private fun hide()
    {
        val anim = TranslateAnimation(0.0f, 0.0f, 0.0f, -(this.height.toFloat()))
        anim.duration = 300
        anim.setAnimationListener(object : Animation.AnimationListener {
            override fun onAnimationStart(animation: Animation?)
            {
            }

            override fun onAnimationEnd(animation: Animation?)
            {
                visibility = View.GONE
                Handler(Looper.getMainLooper()).post {
                    (parent as? ViewGroup)?.removeView(this@EZDropdown)
                }
            }

            override fun onAnimationRepeat(animation: Animation?)
            {
            }
        })
        startAnimation(anim)
    }

    companion object
    {
        fun show(activity: Activity,
                 text: String?,
                 background: Int? = null,
                 foreground: Int? = null)
        {
            if(text != null && text.length > 0)
            {
                var statusBarHeight = 0
                val resourceId = activity.resources.getIdentifier("status_bar_height",
                                                                  "dimen",
                                                                  "android")
                if (resourceId > 0)
                {
                    statusBarHeight = activity.resources.getDimensionPixelSize(resourceId)
                }

                (activity.window.decorView as? ViewGroup)?.let {
                    val dropdown = EZDropdown(activity)
                    dropdown.setTopPadding(statusBarHeight)
                    dropdown.setText(text)
                    dropdown.setBackground(background)
                    dropdown.setForeground(foreground)
                    it.addView(dropdown)
                }
            }
        }
    }
}
